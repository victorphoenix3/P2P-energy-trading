import React, { Component } from "react";

import ThemeProvider from "@material-ui/styles/ThemeProvider";

import AppBar from "@material-ui/core/AppBar";

import TextField from "@material-ui/core/TextField";

import Button from "@material-ui/core/Button";

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



  back = e => {

    e.preventDefault();

    this.props.prevStep();

  };



  render() {

    const { values, handleChange } = this.props;
    const {classes} =this.props;


    return (

      <ThemeProvider>

        <React.Fragment>

	 <AppBar title="Enter User Details" position = "static"  className={mystyles("").root}  >
          <Toolbar textAlign= "center"  className={mystyles("").title} >
           <Typography align="justify" variant="h6" >
             Enter your Energy Requirements
           </Typography>
          </Toolbar>
          </AppBar>

        <br />
	<br/> 

          <TextField            id="filled-basic" label="Amount of Energy" variant="filled"
 

            

            floatingLabelText="Amount of energy"

            onChange={handleChange("Deliveryaddress")}

            defaultValue={values.Deliveryaddress}

          />

          <br />
       	<br/ >
           <TextField
            id="filled-basic" label="Bid Value" variant="filled"


            hintText="Bid Value"

            floatingLabelText="Bid value"

            onChange={handleChange("Phonenumber")}

            defaultValue={values.Phonenumber}

          />

          <br />

          <br />

          <Button


            color="primary"

            variant="contained" 

            // style={styles.button}


            label="Continue"



            style={styles.button}

            onClick={this.continue}

          >
	Continue
	</Button>

          <Button

            label="Back"

            primary={false}
	    color="primary"
	    variant="contained"
           style={styles.button}

            onClick={this.continue}

          >
	Back
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

