# RoomBooking
This is a demo app to check for room availability in the office.

# Requirements
- iOS 12 or later
- Xcode 11 or later

# Language
- Swift 5

# Instruction
1. To compile and run the project, open "RoomBooking.xcodeproj" then press "Command⌘ + R" to build and run the project in iOS Simulator on your mac.
2. To run unit tests, press "Command⌘ + 6" then "Command⌘ + U" to run and view the unit tests.
3. To simulate scanning the QR, please use "test_success.png" and "test_failed.png" found in the root folder. This is to demo the booking is either success or failed.

# Assumption & Limitation
- When selecting a date or time, user is required to "Scroll & Select" and then press "Done" to apply the choice.
- As there is no server to verify the QR code and room booking. This app is only able to validate two valid QR code which are "dGVzdF9zdWNjZXNz" and "dGVzdF9mYWlsZWQ=". If the QR does not contain these codes then it will be an invalid QR format. "dGVzdF9zdWNjZXNz" is to simular a room is booked succesfully and vice versa.