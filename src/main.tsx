import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router'
import Page2 from './pages/page2/Page2.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route index element={<App />} />
        <Route path="/page2" element={<Page2 />}/>
        <Route path="*" element={<Navigate to="/"/>} />
      </Routes>
    </BrowserRouter>
  </StrictMode>,
)
