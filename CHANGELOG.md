# Changelog

## Unreleased

- Added ESP32-DIV V2/V2.1 project guidance in `AGENTS.md`, including ESP32-S3 constraints and Arduino CLI build/upload settings.
- Added Arduino CLI helper scripts for compile, upload, serial monitor, and recovery upload with flash erase.
- Added initial `BoardPins_ESP32DIV_V2.h` hardware map documenting internal, external, future hardware and known pin conflicts.
- Fixed ESP32-S3 link conflict by making `ieee80211_raw_frame_sanity_check` weak.
- Added non-blocking `BuzzerService` and integrated boot success and SubGHz capture beeps.
- Confirmed the integrated buzzer on GPIO 2 and enabled `BUZZER_PIN`.
- Made battery reads safe when `BATTERY_ADC_PIN` is not configured, avoiding `analogRead(-1)` and showing unknown battery as `--%`.
- Added boot diagnostics around battery, menu, status bar, and touchscreen startup.
- Documented ESP32-DIV V2/V2.1 upload recovery settings for white-screen recovery.
- Applied the recommended local TFT_eSPI V2 `User_Setup.h` configuration outside the repository to restore the TFT display.
- Added non-blocking `StatusLedService` for 4 WS2812B LEDs, gated by `settings().neopixelEnabled`, and enabled the confirmed DIN pin on GPIO 1.
- Started real status bar state handling for Wi-Fi/BLE activity and fixed unknown battery handling in the status task.
- Updated foreground Wi-Fi/BLE scans to force status bar redraws and drive WS2812 scan modes during active scans.
- Kept WS2812 scan animations alive during blocking Wi-Fi/BLE scans and preserved manual scan counts in the status bar.
