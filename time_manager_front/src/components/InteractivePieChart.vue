<template>
  <div class="container workingTime mt-5">
    <h2>Work Distribution</h2>
    <div class="row m-5 d-flex justify-content-center">
      <div class="col-sm">
        <label>View work distribution of the: </label>
        <input type="date" v-model="day" v-on:change="updateChart" />
      </div>
    </div>
    <PieChartVue :chart-data="data"  />
  </div>
</template>

<script>
import { defineComponent } from "@vue/runtime-core";
import PieChartVue from "./PieChart.vue";
import axios from "axios";

export default defineComponent({
  name: "InteractivePieChart",
  data() {
    return {
      data: {
        labels : ["No Working Time Found"],
        datasets: [
            {
                backgroundColor: ['#41B883'],
                data: [1]
            }
          ]
      },
      day: new Date().toISOString().substr(0, 10),
    };
  },
  components: {
    PieChartVue,
  },
  methods: {
    async updateChart() {
      let startDate = this.day + "T00:00:01Z";
      let endDate = this.day + "T23:59:59Z";
      var dict = new Map();
      var userNames = [];
      var hours = [];
      var colors= [];
      try{
        var workingtimes = await axios.get(
          `http://localhost:4000/admin/workingtimes?start=${startDate}&end=${endDate}`,{
                  headers: {
                    Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${localStorage.getItem('csrf')}`
                  } 
            }
        )
        let responses = workingtimes.data.length;
        for (let i = 0; i < responses; i++) {
          var start = new Date(workingtimes.data[i].start);
          var end = new Date(workingtimes.data[i].end);
          var users = await axios.get(
              `http://localhost:4000/admin/users/${workingtimes.data[i].user_id}`,{
                  headers: {
                    Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${localStorage.getItem('csrf')}`
                  } 
            }
          )
          var user = users.data.username
          if(!dict.has(user)){
            userNames.push(user);
            dict.set(user,(end-start)/(1000*3600));
          }else{
            dict.set(user,dict.get(user)+(end-start)/(1000*3600));
          }
        }  
        for(let n = 0; n < userNames.length; n++) {
              hours.push(dict.get(userNames[n]));
              colors.push(this.RandomColor());
            }

            this.data = {
            labels : userNames,
              datasets: [
                  {
                      backgroundColor: colors,
                      data: hours
                  }
                ]
            }
      }catch (error){
        alert(error.response.status);
        this.data = {
          labels : ["No Working Time Found"],
          datasets: [
              {
                  backgroundColor: ['#41B883'],
                  data: [1]
              }
            ]
        }
      } 
    },
    RandomColor(){
      var letters = "0123456789ABCDEF";
      var color = '#';
      for (var i = 0; i < 6; i++)
       color += letters[(Math.floor(Math.random() * 16))];
      return color;
    }
  },
  beforeMount() {
    this.updateChart();
  }
});
</script>

<style scoped>
.datePicker {
  width: 300px;
}

.btnValidation {
  background-color: #aaaeb7;
  box-shadow: 1px 1px #e6e4e4;
}

.btnValidation:hover {
  background-color: #8f939c;
}

.workingTime {
  border: #aaaeb7 2px solid;
  border-radius: 4px;
}

.userID {
  display: grid;
}

.userIDInput {
  border: 1px solid #aaaeb7;
  width: 100px;
  border-radius: 4px;
}

.input-group-append {
  cursor: pointer;
}
</style>
