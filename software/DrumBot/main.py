import machine
import time
import network
import socket

# ================= Configuration =================
# --- Actuators ---
KICK1_PIN = 22                 # Transistor 1 (for C1)
KICK2_PIN = 21                 # Transistor 2 (for C#1)
SERVO1_PIN = 8                 # Servo signal (CC1)
MOTOR1_PIN = 20                # Motor PWM transistor (CC2)

# MIDI note numbers to react to (adjust for your DAW's note naming)
#   Many DAWs: C4=60 -> C1 often 36 (Roland/GM style)
#   Others:    C4=60 -> C1 = 24 (Yamaha style)
NOTE_KICK1  = 36   # set to 24 if your system labels C1 at 24
NOTE_KICK2  = 37   # set to 25 accordingly if using 24/25

# Servo config
SERVO_FREQ = 50                # Hz (standard servo)
# Motor PWM config
MOTOR_PWM_FREQ = 20000         # 20 kHz for quiet motor drive

# --- MIDI (DIN) on UART @ 31_250 baud ---
MIDI_UART_ID = 0               # UART0 or UART1; use 0 here
MIDI_RX_PIN = 17               # GP17 as requested (DIN MIDI IN via optocoupler)
MIDI_BAUD = 31250

# --- MIDI Channel Filter ---
# 0 = OMNI (accept all channels), 1..16 = MIDI channel 1..16
MIDI_CHANNEL = 11

# ================ Hardware Setup =================
# Note transistors
kick1 = machine.Pin(KICK1_PIN, machine.Pin.OUT, value=0)
kick2 = machine.Pin(KICK2_PIN, machine.Pin.OUT, value=0)

# Servo
servo1 = machine.PWM(machine.Pin(SERVO1_PIN))
servo1.freq(SERVO_FREQ)

# Motor PWM
motor1_pwm = machine.PWM(machine.Pin(MOTOR1_PIN))
motor1_pwm.freq(MOTOR_PWM_FREQ)
motor1_pwm.duty_u16(0)  # start stopped

# MIDI UART
uart = machine.UART(MIDI_UART_ID, baudrate=MIDI_BAUD, bits=8, parity=None, stop=1, rx=machine.Pin(MIDI_RX_PIN))
uart.init(baudrate=MIDI_BAUD)

# =============== Actuator Helper Functions ================

def _ms_from_velocity(vel):
    """Map MIDI velocity 0..127 to a short pulse in milliseconds."""
    ms = int(vel / 10)  # ~0..12ms
    if ms < 1:
        ms = 1
    return ms


def pulse_pin(pin_obj, ms):
    pin_obj.value(1)
    time.sleep(ms / 1000.0)
    pin_obj.value(0)


def set_servo_angle_from_cc(val):
    """Map CC value 0..127 to 0..180 degrees and write PWM."""
    angle = (val / 127.0) * 180.0
    # Inverted mapping (min/max swapped) as in your version
    min_u16 = 8000
    max_u16 = 1000
    duty = int(min_u16 + (angle / 180.0) * (max_u16 - min_u16))
    servo1.duty_u16(duty)


def set_motor_from_cc(val):
    """Map CC value 0..127 to motor PWM duty 0..65535."""
    duty = int((val & 0x7F) * 65535 / 127 / 10)  # /10: limit output
    motor1_pwm.duty_u16(duty)


def apply_note_on(note, vel):
    if vel <= 0:
        return
    if note == NOTE_KICK1:
        pulse_pin(kick1, _ms_from_velocity(vel))
    elif note == NOTE_KICK2:
        pulse_pin(kick2, _ms_from_velocity(vel))


def apply_cc(ctrl, val):
    if ctrl == 1:
        set_servo_angle_from_cc(val)
    elif ctrl == 2:
        set_motor_from_cc(val)

# ============= MIDI Parsing (UART @ 31.25 kbaud) =============
# Simple running-status MIDI parser for channel voice messages (Note On/Off, CC)
_running_status = 0
_data_bytes_needed = 0
_msg_buf = []


def _channel_ok(status_byte):
    """Return True if the message's channel passes the MIDI_CHANNEL filter.
    MIDI_CHANNEL: 0=OMNI, 1..16 = exact MIDI channel.
    """
    # Only channel voice messages have a channel nibble
    if (status_byte & 0xF0) not in (0x80, 0x90, 0xA0, 0xB0, 0xC0, 0xD0, 0xE0):
        return False  # not a channel voice message -> ignore
    if MIDI_CHANNEL == 0:
        return True  # OMNI
    ch = (status_byte & 0x0F) + 1  # convert 0..15 -> 1..16
    return ch == MIDI_CHANNEL


def _start_status(status):
    global _running_status, _data_bytes_needed, _msg_buf
    if not _channel_ok(status):
        # Reject this running status; consume but ignore following data bytes
        _running_status = 0
        _data_bytes_needed = 0
        _msg_buf = []
        return
    _running_status = status
    _msg_buf = []
    st_hi = status & 0xF0
    if st_hi in (0x80, 0x90, 0xB0):
        _data_bytes_needed = 2
    else:
        _running_status = 0
        _data_bytes_needed = 0


def _emit_message(status, d1, d2=None):
    # Channel already filtered in _start_status
    st_hi = status & 0xF0
    if st_hi == 0x90:  # Note On
        vel = d2 if d2 is not None else 0
        if vel:
            apply_note_on(d1, vel)
    elif st_hi == 0x80:  # Note Off
        pass
    elif st_hi == 0xB0:  # Control Change
        cc = d1
        val = d2 if d2 is not None else 0
        apply_cc(cc, val)


def poll_midi_uart():
    global _running_status, _data_bytes_needed, _msg_buf
    while uart.any():
        b = uart.read(1)
        if not b:
            return
        byte = b[0]
        if byte & 0x80:
            _start_status(byte)
        else:
            if _running_status == 0:
                continue  # ignoring data for a filtered or unsupported status
            _msg_buf.append(byte)
            if len(_msg_buf) >= _data_bytes_needed:
                d1 = _msg_buf[0]
                d2 = _msg_buf[1] if _data_bytes_needed == 2 else None
                _emit_message(_running_status, d1, d2)
                _msg_buf = []

# ============== Main Loop =====================
print('Ready: UART-MIDI active (Channel = {} )'.format('OMNI' if MIDI_CHANNEL == 0 else MIDI_CHANNEL))
while True:
    poll_midi_uart()
    time.sleep(0.001)
