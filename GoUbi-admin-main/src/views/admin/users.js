import React , {useEffect,useState}from 'react'

import {
  CButton,
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
  CFormSwitch
} from '@coreui/react'
import { useNavigate } from "react-router-dom";

import UserDataService from "../../services/users.service";
import HttpService from "../../services/http.service";
import Swal from 'sweetalert2'
import Cookies from 'js-cookie'

const Dashboard = () => {
  
  const [users, setUsers] = useState([]);
  const [rusers, setRusers] = useState([]);
  const navigate = useNavigate();
  useEffect(() => {

    let cookie = Cookies.get('access-token')
    if(!cookie){
      navigate("/login")
    }else{
      getUsers();
    }
    
  }, []);

  const getUsers = async () => {
    Swal.showLoading();
    const data = await UserDataService.getAllUser();
    const lista = data.docs.map((doc) => ({...doc.data(),id:doc.id}));
    setUsers(lista);
    setRusers(lista)
    if(users){
      Swal.close()
    }
  };


  const setSwitch = (flag,id) =>{
    let message = !flag ? "desactivar" : "activar" 
    Swal.fire({
      title: 'Alerta!',
      text: `Seguro Desea ${message} el Usuario`,
      icon: 'warning',
      showCancelButton:true,
      cancelButtonText: 'Cancelar',
      confirmButtonText: 'Ok',
      confirmButtonColor: "#181818", 
    }).then(async (value)=>{
      if(value.isConfirmed){
        Swal.showLoading();
        HttpService.disableUserAxis(id,!flag).then((val)=>{
          if(val.data.sucess){
            getUsers();
          }
        })
        
      }
    })
  }

  const updateList = (info) =>{
    if(info === 'client'){
      let tmp_list = rusers.filter(x=> x.type === 'client')
      setUsers(tmp_list)
    }
    if(info === 'todo'){
      setUsers(rusers)
    }
    if(info === 'delivery'){
      let tmp_list = rusers.filter(x=> x.type !== 'client' && x.type !== 'admin')
      setUsers(tmp_list)
    }
  }

  const searchTextBar = (value) =>{
    if(value.length){
      let tmp_list = rusers.filter(x=>  x.name.toLowerCase().includes(value.toLowerCase()))
      setUsers(tmp_list)
    }else{
      setUsers(rusers)
    }
  }

  const button_style = {
    width: "90px",
    color: "primary"
  }
  const button_style2 = {
    width: "150px",
    color: "primary"
  }

  return (
    <>
      <CCard className="mb-4">
        <CCardHeader>
          <CRow>
            <CCol xs={5}>
              <strong style={{ fontSize: "25px" }} >Usuarios</strong>
            </CCol>
            <CCol xs={1}>
              <CButton style={button_style} onClick={()=>{updateList('todo')}}>Todo</CButton>
            </CCol>
            <CCol xs={1}>
              <CButton style={button_style} onClick={()=>{updateList('client')}} >Clientes</CButton>
            </CCol >
            <CCol xs={2}>
              <CButton style={button_style2} onClick={()=>{updateList('delivery')}}  >Repartidores</CButton>
            </CCol>
            <CCol xs={3}>
              <CFormInput
                type="email"
                id="exampleFormControlInput1"
                placeholder="Escribe un Nombre"
                aria-describedby="exampleFormControlInputHelpInline"
                onChange={(e) => {
                  searchTextBar(e.target.value);
                }}
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
                <CTableHeaderCell scope="col">Nombre</CTableHeaderCell>
                <CTableHeaderCell scope="col">Email</CTableHeaderCell>
                <CTableHeaderCell scope="col">Numero</CTableHeaderCell>
                <CTableHeaderCell scope="col">Cedula</CTableHeaderCell>
                <CTableHeaderCell scope="col">Placa</CTableHeaderCell>
                <CTableHeaderCell scope="col">Estado</CTableHeaderCell>
              </CTableRow>
            </CTableHead>
            <CTableBody>
              
              {users.map((doc, index) => { 
                return(
                <CTableRow key={index}>
                <CTableHeaderCell scope="row">{index+1}</CTableHeaderCell>
                <CTableDataCell>{doc.name} {doc.lastname}</CTableDataCell>
                <CTableDataCell>{doc.email}</CTableDataCell>
                <CTableDataCell>{doc.phone}</CTableDataCell>
                <CTableDataCell>{doc.cedula}</CTableDataCell>
                <CTableDataCell>{doc.placa}</CTableDataCell>
                <CTableDataCell>
            
                  <CFormSwitch  id="formSwitchCheckChecked" checked={!doc.blocked} onChange={(e) => {
                        setSwitch(e.target.checked,doc.id);
                      }}   />
                    
                </CTableDataCell>
              </CTableRow>)
              } )}
            </CTableBody>
          </CTable>
          </CRow>

        </CCardBody>
        <CCardFooter>
         
        </CCardFooter>
      </CCard>

    </>
  )
}

export default Dashboard
