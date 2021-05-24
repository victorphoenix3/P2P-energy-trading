import React, { Component } from "react";

import ThemeProvider from "@material-ui/styles/ThemeProvider";

import AppBar from "@material-ui/core/AppBar";

import { List, ListItem } from "@material-ui/core";

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



export class Confirm extends Component {

  continue = e => {

    e.preventDefault();

    this.props.nextStep();

  };



  back = e => {

    e.preventDefault();

    this.props.prevStep();

  };



  render() {

    const {

      values: {

        firstName,

        lastName,

        email,

        Deliveryaddress,

        Phonenumber,

        Phonenumber2,

        Country,

        city,

        payment

      }

    } = this.props;
   
    const {classes}= this.props;


    return (

      <ThemeProvider>

        <React.Fragment>

          <AppBar title="Enter User Details" position = "static"  className={mystyles("").root}  >
          <Toolbar textAlign= "center"  className={mystyles("").title} >
           <Typography align="justify" variant="h6" >
             CONFIRM YOUR DETAILS
           </Typography>
          </Toolbar>
          </AppBar>



          <List>

            <ListItem primaryText="First Name" secondaryText={firstName} />

            <ListItem primaryText="Last Name" secondaryText={lastName} />

            <ListItem primaryText="Email" secondaryText={email} />

            <ListItem

              primaryText="Delivery Address"

              secondaryText={Deliveryaddress}

            />

            <ListItem

              primaryText="Phone Number 1"

              secondaryText={Phonenumber}

            />

            <ListItem

              primaryText="Phone Number 2"

              secondaryText={Phonenumber2}

            />

            <ListItem primaryText="Country" secondaryText={Country} />

            <ListItem primaryText="City" secondaryText={city} />

            <ListItem primaryText="Payemnt" secondaryText={payment} />

          </List>



          <br />

	<Button
            label="Confirm And Continue"
		color="primary"
		variant="contained"

            style={styles.button}

            onClick={this.continue}

          > Confirm and Continue
 	</Button>

          <Button

            label="Back"
		color="primary"
		variant="contained"
            primary={false}

            style={styles.button}

            onClick={this.continue}
        > Back </Button>

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

export default Confirm;

