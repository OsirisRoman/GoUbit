import React from 'react'
import { useState, useEffect } from "react";
import {db} from "./firebase"

import {
  collection,
  getDocs,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
} from "firebase/firestore";

import {
  CAvatar,
  CButton,
  CButtonGroup,
  CCard,
  CCardBody,
  CCardFooter,
  CCardHeader,
  CCol,
  CFormInput,
  CRow,
  CTable,
  CTableBody,
  CTableHead,
  CTableRow,
  CTableHeaderCell,
  CTableDataCell,
  CCardText


} from '@coreui/react'


const Dashboard = () => {

  const button_style = {
    width: "90px",
    color: "primary",

  }


  const [users, setUsers] = useState([]);


  useEffect(() => {
    const getUsers = async () => {

      const userCollectionRef = collection(db, "users");

      const data = await getDocs(userCollectionRef);
      console.log("elemeto "+ data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
      setUsers(data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));

};
    getUsers();
  }, []);

  const handleSubmit = async () => {

    const userCollectionRef = collection(db, "users");

    const data = await getDocs(userCollectionRef);
      console.log("elemeto "+ data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
      setUsers(data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
  };

  const handleSubmitGas =  async () => {

    const userCollectionRef = collection(db, "users");

    const data = await getDocs(userCollectionRef);

    for(let key in data.docs.map((doc) => ({ ...doc.data(), id: doc.id }))) {

      if ((data.docs.map((doc) => ({ ...doc.data(), id: doc.id }))[key].name) === "gas") {
        setUsers(data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
       } else {
       setUsers(data.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
       }
    }
  };

  const handleSubmitRecicle =  async () => {

    const userCollectionRef = collection(db, "users");

    const data2 = await getDocs(userCollectionRef);

    for(let key2 in data2.docs.map((doc) => ({ ...doc.data(), id: doc.id }))) {

      if ((data2.docs.map((doc) => ({ ...doc.data(), id: doc.id }))[key2].name) === "recicle") {

        setUsers(data2.docs.map((doc) => ({ ...doc.data(), id: doc.id })));
      }
    }
  };



  return (


<>
      <CCard className="mb-4">

        <CCardHeader>
          <CRow>
            <CCol xs={5}>
              <strong style={{ fontSize: "25px" }} >Usuarios</strong>
            </CCol>
            <CCol xs={1}>
              <CButton onClick={handleSubmit} style={button_style} >Todos</CButton>
            </CCol>
            <CCol xs={1}>
              <CButton   onClick={handleSubmitGas} style={button_style} >Gas</CButton>
            </CCol >
            <CCol xs={1}>
              <CButton   onClick={handleSubmitGas} style={button_style} >Agua</CButton>
            </CCol>
            <CCol xs={1}>
              <CButton   onClick={handleSubmitRecicle}  style={button_style} >Chatarra</CButton>
            </CCol>
            <CCol xs={3}>
              <CFormInput
                type="email"
                id="exampleFormControlInput1"
                placeholder="Escribe un Nombre"
                aria-describedby="exampleFormControlInputHelpInline"
              />
            </CCol>
          </CRow>
        </CCardHeader>

        <CCardBody>

        <CRow>

        </CRow>
        <CRow >

          <CTable striped>
            <CTableHead>
              <CTableRow>
                <CTableHeaderCell scope="col">No</CTableHeaderCell>
                <CTableHeaderCell scope="col">Conductor</CTableHeaderCell>
                <CTableHeaderCell scope="col">Email</CTableHeaderCell>
                <CTableHeaderCell scope="col">Numero</CTableHeaderCell>
                <CTableHeaderCell scope="col">Cedula</CTableHeaderCell>
                <CTableHeaderCell scope="col">Placa</CTableHeaderCell>
              </CTableRow>
            </CTableHead>
            <CTableBody>
              {users.map((user) => (
                 <CTableRow key={user.name}>
                 <CTableDataCell>NO EXITE EN BD</CTableDataCell>
                 <CTableDataCell>{user.name}</CTableDataCell>
                 <CTableDataCell>{user.email}</CTableDataCell>
                 <CTableDataCell>NO EXITE EN BD</CTableDataCell>
                 <CTableDataCell>NO EXITE EN BD</CTableDataCell>
                 <CTableDataCell>NO EXITE EN BD</CTableDataCell>
               </CTableRow>

            ))}
            </CTableBody>
          </CTable>
          </CRow>

        </CCardBody>
        <CCardFooter>

        </CCardFooter>
      </CCard>

    </>

  )
  //{users.map((user) => { })};

}

export default Dashboard
