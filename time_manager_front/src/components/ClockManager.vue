<template>
    <div class="clock">
        <div id="bigbutton" @click="createClock">{{ labelButton }}</div>
        <div>
            <InteractiveBarChartVue></InteractiveBarChartVue>
        </div>
    </div>
</template>

<script>
import InteractiveBarChartVue from "./InteractiveBarChart.vue";
import axios from "axios";
export default {
    name: "ClockManager",
    data() {
        return {
            userID: 0,
            clockStatus: "",
            labelButton: ""
        };
    },
    components: {
        InteractiveBarChartVue
    },
    methods: {
        createClock() {
            if (localStorage.getItem("roleID") == 2) {
                this.labelButton = "Loading..."
                const config = {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                        "x-csrf-token": `${localStorage.getItem('csrf')}`
                    }
                };

                axios
                    .post(`http://localhost:4000/admin/clocks/1`, {}, config)
                    .then((response) => {
                        console.log("Pointage pris en compte");
                    })
                    .catch((error) => {
                        console.log(error.response.status);
                    });
            }
            else {
                const config = {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                        "x-csrf-token": `${localStorage.getItem('csrf')}`
                    }
                };
                axios
                    .post(`http://localhost:4000/user/clocks/`, {}, config)
                    .then((response) => {
                        console.log("Pointage pris en compte");
                    })
                    .catch((error) => {
                        console.log(error.response.status);
                    });
            }
            this.getLastClock();
        },
        getLastClock() {
            if (localStorage.getItem('roleID') == 2) {
                axios.get(
                    `http://localhost:4000/admin/clocks/1`, {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                        "x-csrf-token": `${localStorage.getItem('csrf')}`
                    }
                })
                    .then((response) => {
                        console.log(response.data);
                        this.clockStatus = response.data.at(-1).status;
                        console.log(this.clockStatus);
                        if (this.clockStatus == true) {
                            this.labelButton = 'Clock-out';
                            $('#bigbutton').css('background-color', '#f73030');
                            $('#bigbutton').css('box-shadow', '0 20px #960b0b');
                        }
                        else {
                            this.labelButton = 'Clock-in';
                            $('#bigbutton').css('background-color', '#4caf50');
                            $('#bigbutton').css('box-shadow', '0 20px #368a38');
                        }
                    }
                    )
                    .catch((error) => {
                        console.log(error.response.status);
                    });
            }
            else {
                axios.get(
                    `http://localhost:4000/user/clocks`, {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                        "x-csrf-token": `${localStorage.getItem('csrf')}`
                    }
                })
                    .then((response) => {
                        console.log(response.data);
                        this.clockStatus = response.data.at(-1).status;
                        console.log(this.clockStatus);
                        if (this.clockStatus == true) {
                            this.labelButton = 'Clock-out';
                            $('#bigbutton').css('background-color', '#f73030');
                            $('#bigbutton').css('box-shadow', '0 20px #960b0b');
                        }
                        else {
                            this.labelButton = 'Clock-in';
                            $('#bigbutton').css('background-color', '#4caf50');
                            $('#bigbutton').css('box-shadow', '0 20px #368a38');
                        }
                    }
                    )
                    .catch((error) => {
                        console.log(error.response.status);
                    });
            }

        }
    },
    beforeMount() {
        this.getLastClock();
    }
}
</script>

<style scoped>
.clock {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

/*.clock button:focus {
    border-style: outset;
}

.clock button:hover {
    color: white;
}

.clock button {
    width: 14em;
    height: 14em;
    background-color: #4caf50;
    border: none;
    border-radius: 55%;
    color: #575151;
    font-size: 20px;
    font-weight: 700;
    border-style: inset;
    border-color: #4caf50;
}*/
#bigbutton {
    width: 180px;
    height: 120px;
    background-color: #4caf50;
    color: #ffffff;
    font-family: sans-serif;
    font-size: 16px;
    text-align: center;
    line-height: 100px;
    border-radius: 50%;
    margin: 30px;
    box-shadow: 0 20px #368a38;
    font-weight: bold;
}

/*#bigbutton:hover {
    background-color: #ff0080;
    color: yellow;
    font-size: 22px;
    box-shadow: 0 20px #a82466;
}*/

#bigbutton:active {
    background-color: #4caf50;
    color: #2c2a2a;
    box-shadow: 0 10px #368a38;
    transform: translateY(10px);
}
</style>