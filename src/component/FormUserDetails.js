import React, { Component } from "react";
import { render } from 'react-dom';
import ThemeProvider from "@material-ui/styles/ThemeProvider";
import AppBar from "@material-ui/core/AppBar";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import FormHelperText from '@material-ui/core/FormHelperText';
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


export class FormUserDetails extends Component {


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
     	     ENTER YOUR DETAILS
    	   </Typography>
	  </Toolbar>
	  </AppBar>
	  
	  <br / >
          
	  <TextField
	    id="filled-basic" label="Enter your First Name" variant="filled"
            //hintText="Enter your First Name"

            floatingLabelText="First Name"

            onChange={handleChange("firstName")}

            defaultValue={values.firstName}

          />

          <br />
	 <br />
          <TextField
	    id="filled-basic" label="Enter your Last Name" variant="filled"
            
            floatingLabelText="Last Name"

            onChange={handleChange("lastName")}

            defaultValue={values.lastName}

          />

          <br />
	<br />
          <TextField
	    id="filled-basic" label="Enter your Email" variant="filled" 
            

            floatingLabelText="Email"

            onChange={handleChange("email")}

            defaultValue={values.email}

          />

          <br />
	  <br />
          <Button

            label="Continue"

            color="primary"
	    
	    variant="contained" 
            
	    // style={styles.button}

            onClick={this.continue}

          > 
	 Continue
	</Button>

        </React.Fragment>

      </ThemeProvider>

    );

  }

}



const styles = {

  button: {

    margin: 15

  }

};

export default FormUserDetails;

