const functions = require('firebase-functions/v2');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

// Create a Nodemailer transporter using SMTP with environment variables
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: functions.config().email?.user || process.env.EMAIL_USER,
    pass: functions.config().email?.password || process.env.EMAIL_PASSWORD,
  },
});

// Generate a random 6-digit verification code
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// Function to check if a user's Purdue email is already verified
exports.checkPurdueEmailVerification = functions.https.onCall(async (data, context) => {
  try {
    // Check if the user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'You must be logged in to check verification status'
      );
    }

    const userId = context.auth.uid;
    const userDoc = await admin.firestore().collection('users').doc(userId).get();

    if (!userDoc.exists) {
      return { verified: false };
    }

    const userData = userDoc.data();
    return { 
      verified: userData.isPurdueVerified || false,
      purdueEmail: userData.purdueEmail || null
    };
  } catch (error) {
    console.error('Error checking verification status:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to check verification status. Please try again.'
    );
  }
});

// Function to send verification code to Purdue email
exports.sendPurdueVerificationCode = functions.https.onCall(async (data, context) => {
  try {
    const { email } = data;
    
    // Validate that the email is a Purdue email
    if (!email.endsWith('@purdue.edu')) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Email must be a valid Purdue email address'
      );
    }
    
    // Generate a verification code
    const verificationCode = generateVerificationCode();
    
    // Store the verification code in Firestore with expiration time (30 minutes)
    const expirationTime = Date.now() + 30 * 60 * 1000; // 30 minutes from now
    
    await admin.firestore().collection('verificationCodes').doc(email).set({
      code: verificationCode,
      expiresAt: expirationTime,
      createdAt: Date.now(),
      verified: false
    });
    
    // Send email with verification code
    const mailOptions = {
      from: 'Your App <noreply@yourdatingapp.com>',
      to: email,
      subject: 'Your Purdue Email Verification Code',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2>Verify Your Purdue Email</h2>
          <p>Thank you for using our app! Please use the following verification code to verify your Purdue email address:</p>
          <div style="background-color: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; margin: 20px 0;">
            ${verificationCode}
          </div>
          <p>This code will expire in 30 minutes.</p>
          <p>If you didn't request this code, you can safely ignore this email.</p>
        </div>
      `
    };
    
    await transporter.sendMail(mailOptions);
    
    return { success: true, message: 'Verification code sent successfully' };
  } catch (error) {
    console.error('Error sending verification code:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send verification code. Please try again later.'
    );
  }
});

// Function to verify the code entered by user
exports.verifyPurdueEmail = functions.https.onCall(async (data, context) => {
  try {
    const { email, code } = data;
    
    // Get the stored verification code
    const verificationDoc = await admin.firestore().collection('verificationCodes').doc(email).get();
    
    if (!verificationDoc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'No verification code found for this email'
      );
    }
    
    const verificationData = verificationDoc.data();
    const currentTime = Date.now();
    
    // Check if the code has expired
    if (currentTime > verificationData.expiresAt) {
      throw new functions.https.HttpsError(
        'deadline-exceeded',
        'Verification code has expired. Please request a new one.'
      );
    }
    
    // Check if the code matches
    if (code !== verificationData.code) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Invalid verification code'
      );
    }
    
    // Mark the verification code as verified
    await admin.firestore().collection('verificationCodes').doc(email).update({
      verified: true,
      verifiedAt: currentTime
    });
    
    // If user is authenticated, update their profile
    if (context.auth && context.auth.uid) {
      await admin.firestore().collection('users').doc(context.auth.uid).update({
        isPurdueVerified: true,
        purdueEmail: email
      });
    }
    
    return { success: true, message: 'Email verified successfully' };
  } catch (error) {
    console.error('Error verifying code:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message || 'Failed to verify code. Please try again.'
    );
  }
}); 