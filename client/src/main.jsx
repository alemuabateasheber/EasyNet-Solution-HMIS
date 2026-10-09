import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./styles.css";

class AppErrorBoundary extends React.Component {
  constructor(props){super(props);this.state={error:null}}
  static getDerivedStateFromError(error){return {error}}
  componentDidCatch(error,info){console.error("EasyNet HIS render error",error,info)}
  render(){
    if(this.state.error){
      return <div style={{minHeight:"100vh",display:"grid",placeItems:"center",padding:24,fontFamily:"\"Noto Sans\", \"Noto Sans Ethiopic\", Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif",background:"#f6f8fb"}}>
        <div style={{maxWidth:680,width:"100%",background:"white",border:"1px solid #e5e7eb",borderRadius:16,padding:28,boxShadow:"0 12px 40px rgba(15,23,42,.08)"}}>
          <h1 style={{margin:"0 0 8px",fontSize:22}}>EasyNet HIS could not render this page</h1>
          <p style={{margin:"0 0 18px",color:"#64748b"}}>The application caught a frontend error instead of showing a blank screen. Refresh the page and, if it continues, send this error to the administrator.</p>
          <pre style={{whiteSpace:"pre-wrap",background:"#f8fafc",padding:14,borderRadius:10,overflow:"auto",fontSize:12}}>{String(this.state.error?.message||this.state.error)}</pre>
          <button onClick={()=>window.location.reload()} style={{marginTop:16,padding:"10px 16px",border:0,borderRadius:9,cursor:"pointer"}}>Reload EasyNet HIS</button>
        </div>
      </div>;
    }
    return this.props.children;
  }
}

createRoot(document.getElementById("root")).render(
  <React.StrictMode><AppErrorBoundary><App /></AppErrorBoundary></React.StrictMode>
);