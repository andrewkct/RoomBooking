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

# Assumption
- When selecting a date or time, user is required to "Scroll & Select" and then press "Done" to apply the choice.
- When applying a sort, user is required to press "Apply" to apply a sort type whereas pressing "Reset" will remove selected sort type.
- As there is no server to validate the QR code and room booking. This app is only able to validate two QR code which are "dGVzdF9zdWNjZXNz" and "dGVzdF9mYWlsZWQ=". If the QR does not contain these codes then it will be an invalid QR format. "dGVzdF9zdWNjZXNz" is to simulate a room is booked succesfully whereas "dGVzdF9mYWlsZWQ=" is to simulate failing to book a room.