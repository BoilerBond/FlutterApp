// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyD4yIiQ30J2FnfdgAHPi5irt33WsljaaSA",
  authDomain: "purduedatingapp.firebaseapp.com",
  databaseURL: "https://purduedatingapp-default-rtdb.firebaseio.com",
  projectId: "purduedatingapp",
  storageBucket: "purduedatingapp.firebasestorage.app",
  messagingSenderId: "434594544336",
  appId: "1:434594544336:web:b5ae1da3c72d5c9c0bfcd5"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Configure Firebase Auth to use email link authentication
if (firebase.auth) {
  firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL);
  console.log("Firebase Auth configured for email link authentication");
} 