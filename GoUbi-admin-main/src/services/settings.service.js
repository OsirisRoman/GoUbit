import { db } from "../firebase";

import {
  getDoc,
  getDocs,
  updateDoc,
  collection,
  doc,
} from "firebase/firestore";

const userCollectionRef = collection(db, "settings");
class SettingsDataService {

  updateSettings = (updatedBook) => {
    const bookDoc = doc(db, "settings", "data");
    return updateDoc(bookDoc, updatedBook);
  };

  getSettings = () => {
    const userDoc = doc(db, "settings", "data");
    return getDoc(userDoc);
  };

  getAll = () => {
    return getDocs(userCollectionRef);
  };
}

export default new SettingsDataService();