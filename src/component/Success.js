import React, { Component } from "react";

import ThemeProvider from "@material-ui/styles/ThemeProvider";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from '@material-ui/core/Toolbar'; 
import Typography from '@material-ui/core/Typography';
import {  withStyles } from '@material-ui/core/styles';


const mystyles = theme => ({
  root: {
    flexGrow: 1,
    boxShadow: "none",
    backgroundColor: "#ffffff",
    alignItems : 'center',
  },
  
  title: {
    flexGrow: 1,
  },
});




export class Success extends Component {

  continue = e => {

    e.preventDefault();

    this.props.nextStep();

  };



  render() {

    const { values, handleChange } = this.props;
     const {classes}= this.props;



    return (

      <ThemeProvider>

        <React.Fragment>

           <AppBar title="Enter User Details" position = "static"  className={mystyles("").root}  >
          <Toolbar textAlign= "center"  className={mystyles("").title} >
           <Typography align="justify" variant="h6" >
            TRANSACTION ORDER PLACED
           </Typography>
          </Toolbar>
          </AppBar>


          <h1>Thank you for your transaction order</h1>

          <p>Kindly wait for the bidding period to end.</p>

        </React.Fragment>

      </ThemeProvider>

    );

  }

}

export default Success;

