# Firebase Functions for Purdue Email Verification

This directory contains Firebase Cloud Functions used for Purdue email verification in the dating app.

## Setup Instructions

1. Make sure you have the Firebase CLI installed:
   ```
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```
   firebase login
   ```

3. Install dependencies:
   ```
   cd functions
   npm install
   ```

4. Add environment variables for email sending:
   ```
   firebase functions:config:set email.user="your-email@gmail.com" email.password="your-app-password"
   ```
   
   Note: For Gmail, you need to use an "App Password" rather than your regular password. You can generate one in your Google Account settings.

5. Deploy the functions:
   ```
   firebase deploy --only functions
   ```

## Functions Overview

### sendPurdueVerificationCode

This function generates and sends a 6-digit verification code to the provided Purdue email address.

- **Input**: `{ email: "user@purdue.edu" }`
- **Output**: `{ success: true, message: "Verification code sent successfully" }`
- **Errors**:
  - If the email is not a valid Purdue email
  - If the email sending fails

### verifyPurdueEmail

This function verifies the code entered by the user and marks their account as verified.

- **Input**: `{ email: "user@purdue.edu", code: "123456" }`
- **Output**: `{ success: true, message: "Email verified successfully" }`
- **Errors**:
  - If no verification code is found for the email
  - If the code has expired (30 minutes)
  - If the code is incorrect

## Firestore Collections

The functions use the following Firestore collections:

- **verificationCodes**: Stores verification codes and their expiration times
  - Document ID: user's email
  - Fields:
    - `code`: The 6-digit verification code
    - `expiresAt`: Timestamp when the code expires
    - `createdAt`: Timestamp when the code was created
    - `verified`: Boolean indicating if the code has been verified
    - `verifiedAt`: Timestamp when the code was verified (if applicable)

- **users**: User profiles with verification status
  - Document ID: Firebase Auth UID
  - Fields related to verification:
    - `isPurdueVerified`: Boolean indicating if the user's Purdue email is verified
    - `purdueEmail`: The verified Purdue email address 