<template>
    <div>
    <h1>
        Epic-Tech Time Manager
    </h1>
    <div class="login-page" v-if="!isConnected">
        <div class="form">
            <form class="register-form">

                <input type="text" placeholder="First name" v-model="firstname" />
                <input type="text" placeholder="Last name" v-model="lastname" />
                <input type="text" placeholder="Email address" v-model="emailRegister" />
                <input type="password" placeholder="Password" v-model="passwordRegister" />
                <button @click="createUser">create</button>
                <p class="message" v-on:click="changeform">Already registered? <a href="#">Sign In</a></p>
            </form>
            <form>
                <input type="text" placeholder="email" v-model="emailLogin" />
                <input type="password" placeholder="password" v-model="passwordLogin" />
                <button v-on:click="loginUser">login</button>
                <p class="message" v-on:click="changeform">Not registered? <a href="#">Create an account</a></p>
            </form>
        </div>
    </div>
</div>
    <ClockManagerVue v-if="isConnected" />
</template>

<script>
import ClockManagerVue from "./ClockManager.vue";
import axios from "axios";
export default {
    name: "Home",
    components: {
        ClockManagerVue
    },
    data() {
        return {
            id: 0,
            emailRegister: "",
            firstname: "",
            lastname: "",
            passwordRegister: "",
            emailLogin: "",
            passwordLogin: "",
            jwt: "",
            csrf: "",
            roleID: "",
            jwtPayload: "",
            userID:"",
            isConnected: false
        };
    },
    methods: {
        checkIfConnected() {
            this.isConnected = (window.localStorage.getItem('roleID') != null);
        },
        changeform(event) {
            $('form').animate({ height: "toggle", opacity: "toggle" }, "slow");
        },
        loginUser() {
            axios
                .post(
                    `http://localhost:4000/auth/login`, {
                    email: this.emailLogin,
                    password: this.passwordLogin
                }
                )
                .then((response) => {
                    console.log("Connexion avec succès");
                    this.jwt = response.data;
                    this.jwtPayload = atob(this.jwt.split('.')[1]);
                    this.csrf = JSON.parse(this.jwtPayload).xsrf;
                    this.roleID = JSON.parse(this.jwtPayload)['roleID'];
                    this.userID = JSON.parse(this.jwtPayload).userID;
                    window.localStorage.setItem('jwt', this.jwt);
                    window.localStorage.setItem('csrf', this.csrf);
                    window.localStorage.setItem('roleID', this.roleID);
                    window.localStorage.setItem('userID', this.userID);
                    this.$router.push('/Clock/1')
                    this.isConnected = true;
                })
                .catch((error) => {
                    console.log(error.response);
                });
        },
        createUser() {
            console.log(this.email, this.username);
            axios
                .post(`http://localhost:4000/auth/register`, {
                    email: this.emailRegister,
                    username: this.firstname,
                    password: this.passwordRegister
                })
                .then((response) => {
                    alert('account created succesfuly');
                    console.log(response);
                    console.log("Automatically Connecting");
                    this.emailLogin = this.emailRegister;
                    this.passwordLogin = this.passwordRegister;
                    this.loginUser();
                })
                .catch((error) => {
                    alert('something went wrong')
                    console.log(error.response.status);
                });
        },
    },
    beforeMount() {
        this.checkIfConnected();
    },
    mounted() {
        setInterval(() => {
            this.checkIfConnected();
            console.log("a");
        }, 1000);
    }
}
</script>

<style scoped>

.login-page {
    width: 360px;
    padding: 8% 0 0;
    margin: auto;
}

.form {
    position: relative;
    z-index: 1;
    background: #FFFFFF;
    max-width: 360px;
    margin: 0 auto 100px;
    padding: 45px;
    text-align: center;
    box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}

.form input {
    font-family: sans-serif;
    outline: 0;
    background: #f2f2f2;
    width: 100%;
    border: 0;
    margin: 0 0 15px;
    padding: 15px;
    box-sizing: border-box;
    font-size: 14px;
}

.form button {
    font-family: sans-serif;
    text-transform: uppercase;
    outline: 0;
    background: #4CAF50;
    width: 100%;
    border: 0;
    padding: 15px;
    color: #FFFFFF;
    font-size: 14px;
    -webkit-transition: all 0.3 ease;
    transition: all 0.3 ease;
    cursor: pointer;
}

.form button:hover,
.form button:active,
.form button:focus {
    background: #43A047;
}

.form .message {
    margin: 15px 0 0;
    color: #b3b3b3;
    font-size: 12px;
}

.form .message a {
    color: #4CAF50;
    text-decoration: none;
}

.form .register-form {
    display: none;
}

.container {
    position: relative;
    z-index: 1;
    max-width: 300px;
    margin: 0 auto;
}

.container:before,
.container:after {
    content: "";
    display: block;
    clear: both;
}

.container .info {
    margin: 50px auto;
    text-align: center;
}

.container .info h1 {
    margin: 0 0 15px;
    padding: 0;
    font-size: 36px;
    font-weight: 300;
    color: #1a1a1a;
}

.container .info span {
    color: #4d4d4d;
    font-size: 12px;
}

.container .info span a {
    color: #000000;
    text-decoration: none;
}

.container .info span .fa {
    color: #EF3B3A;
}

body {
    background: #76b852;
    /* fallback for old browsers */
    background: rgb(141, 194, 111);
    background: linear-gradient(90deg, rgba(141, 194, 111, 1) 0%, rgba(118, 184, 82, 1) 50%);
    font-family: sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

h1 {
    color: #4CAF50;
    margin-top: 2rem;
    font-size: xxx-large;
    text-align: center;
}
</style>
