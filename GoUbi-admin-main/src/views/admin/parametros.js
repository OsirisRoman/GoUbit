import React , {useEffect,useState}from 'react'

import {
  CButton,
  CCard,
  CCardBody,
  CFormLabel,
  CCardHeader,
  CCol,
  CFormInput,
  CRow,
  CContainer
} from '@coreui/react'

import Swal from 'sweetalert2'
import { useNavigate } from "react-router-dom";

import SettingsDataService from "../../services/settings.service";
import Cookies from 'js-cookie'

const Dashboard = () => {

  const navigate = useNavigate();
  const [radio1,setRadio1]=useState(0)
  const [radio2,setRadio2]=useState(0)
  const [tiempo,setTiempo]=useState(0)
  useEffect(() => {
    let cookie = Cookies.get('access-token')
    if(!cookie){
      navigate("/login")
    }else{
      getSettings();
    }
  }, []);
  
  const getSettings = async () => {
    Swal.showLoading();
    const data = await SettingsDataService.getSettings()
    if(data){
      let tmpdata = data.data()
      setRadio1(tmpdata.radio_1)
      setRadio2(tmpdata.radio_2)
      setTiempo(tmpdata.tiempo)
      Swal.close()
    }
  };

  const submitInfo = () =>{
    Swal.showLoading();
    SettingsDataService.updateSettings({
      radio_1: parseInt(radio1),
      radio_2: parseInt(radio2),
      tiempo : parseInt(tiempo)
    }).then((val)=>{
      Swal.close()
    }).catch((err)=>{
      console.log(err)
    })
  }



  return (
    <>
      <CCard className="mb-4">
        <CCardHeader>
          <CRow>
            <CCol xs={5}>
              <strong style={{ fontSize: "25px" }} >Parametros</strong>
            </CCol>
          </CRow>
        </CCardHeader>

        <CCardBody>
        <CContainer>

       
        <CRow>
          <CCol xs={6}>
          <CFormLabel >Radio de Solicitud Principal (Km)</CFormLabel>
            <CFormInput
                type="text"
                id="radioSolicitud"
                value={radio1}
                onChange={event => setRadio1(event.target.value)}
                aria-describedby="exampleFormControlInputHelpInline"
              />
          </CCol>
          <CCol xs={6}>
          <CFormLabel >Tiempo de espera (Minutos)</CFormLabel>
            <CFormInput
                type="text"
                id="tiempoespera"
                value={tiempo}
                onChange={event => setTiempo(event.target.value)}
                aria-describedby="exampleFormControlInputHelpInline"
                
              />
          </CCol>
        </CRow>
        <CRow >
          <CCol xs={6} style={{marginTop:"1em"}}>
          <CFormLabel >Radio de Solicitud secundario (Km)</CFormLabel>
          <CFormInput
                  type="text"
                  id="radioSolicitud2"
                  value={radio2}
                  onChange={event => setRadio2(event.target.value)}
                  aria-describedby="exampleFormControlInputHelpInline"
                />
          </CCol>
        </CRow>
        
        <CRow >
          <CButton style={{ width: "100px",color: "primary",marginTop:"2em"}} onClick={()=>{submitInfo()}} >Actualizar</CButton>
        </CRow>
        </CContainer>
        </CCardBody>
        
      </CCard>

    </>
  )
}

export default Dashboard
