import { initializeApp } from "firebase/app";
import { getFirestore } from "@firebase/firestore";
import "firebase/compat/auth";

// For Firebase JS SDK v7.20.0 and later, measurementId is optional

const firebaseConfig = {

  apiKey: "AIzaSyCdnL5XkJdxGiiQNXrlv9XteT23DnU5W_c",

  authDomain: "aplios.firebaseapp.com",

  databaseURL: "https://aplios-default-rtdb.firebaseio.com",

  projectId: "aplios",

  storageBucket: "aplios.appspot.com",

  messagingSenderId: "257327159034",

  appId: "1:257327159034:web:4072849b8fcd597a5b1b43",

  measurementId: "G-0FSYP29802"

};

const app = initializeApp(firebaseConfig);

export const db = getFirestore(app);
