import React from 'react'

const Dashboard = React.lazy(() => import('./views/dashboard/Dashboard'))

const Users = React.lazy(() => import('./views/admin/users'))
const Solicitudes = React.lazy(() => import('./views/admin/solicitudes'))
const Parametros = React.lazy(() => import('./views/admin/parametros'))
const Terminos = React.lazy(() => import('./views/admin/terminos'))


const routes = [
  { path: '/', exact: true, name: 'Home' },
  { path: '/dashboard', name: 'Dashboard', element: Dashboard },
  { path: '/users', name: 'Users', element: Users },
  { path: '/solicitudes', name: 'Solicitudes', element: Solicitudes },
  { path: '/parametros', name: 'Parametros', element: Parametros },
  { path: '/terminos', name: 'Terminos', element: Terminos },
]

export default routes
