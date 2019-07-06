from datetime import datetime
from enum import Enum
from typing import Optional

from dataclasses import dataclass, field

from .event import Event

# Logged-in accounts

@dataclass
class AccountUpdated(Event):
    user_id: str = field()


@dataclass
class AccountDeleted(Event):
    user_id: str = field()


# Accounts and room members details

@dataclass
class UserUpdated(Event):
    user_id:        str = field()
    display_name:   str = ""
    avatar_url:     str = ""
    status_message: str = ""


# Devices

class Trust(Enum):
    blacklisted = -1
    undecided   = 0
    trusted     = 1


@dataclass
class DeviceUpdated(Event):
    user_id:        str      = field()
    device_id:      str      = field()
    ed25519_key:    str      = field()
    trust:          Trust    = Trust.undecided
    display_name:   str      = ""
    last_seen_ip:   str      = ""
    last_seen_date: datetime = field(default_factory=lambda: datetime(1, 1, 1))


@dataclass
class DeviceDeleted(Event):
    user_id:   str = field()
    device_id: str = field()