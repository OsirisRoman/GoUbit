import React from 'react'

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
  CCardText,
  CContainer
  

} from '@coreui/react'

const Dashboard = () => {

  const button_style = {
    width: "90px",
    color: "primary"
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
            <CFormInput
                type="text"
                id="radioSolicitud"
                placeholder="Radio de Solicitud principal"
                aria-describedby="exampleFormControlInputHelpInline"
              />
          </CCol>
          <CCol xs={6}>
            <CFormInput
                type="text"
                id="tiempoespera"
                placeholder="Tiempo de espera"
                aria-describedby="exampleFormControlInputHelpInline"
              />
          </CCol>
        </CRow>
    
        <CRow >
          <CCol xs={6} style={{marginTop:"1em"}}>
          <CFormInput
                  type="text"
                  id="radioSolicitud2"
                  placeholder="Radio de Solicitud secundario"
                  aria-describedby="exampleFormControlInputHelpInline"
                />
          </CCol>
        </CRow>
        
        <CRow >
          <CButton style={{ width: "100px",color: "primary",marginTop:"2em"}} >Actualizar</CButton>
        </CRow>
        </CContainer>
        </CCardBody>
        
      </CCard>

    </>
  )
}

export default Dashboard
