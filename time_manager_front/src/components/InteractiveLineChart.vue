<template>
  <div class="container workingTime mt-5">
    <h2>Work week summary</h2>
    <LineChartVue :chart-data="data"  />
  </div>
</template>

<script>
import { defineComponent } from "@vue/runtime-core";
import LineChartVue from "./LineChart.vue";
import axios from "axios";

export default defineComponent({
  name: "InteractiveLineChart",
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
    LineChartVue,
  },
  props:{
    Uid : {
      type: Number,
      default: 0
    }
  },
  methods: {
    async updateChart() {
      if(localStorage.getItem('roleID')==2){
        let monday = this.getDayOfCurrentWeek(1).toISOString().substr(0, 10);
        let sunday = this.getDayOfCurrentWeek(7).toISOString().substr(0, 10);

        let startDate = monday + "T00:00:01Z";
        let endDate = sunday + "T23:59:59Z";

        var hours = new Map();
        var hoursF= [];

        var colors= [];
        try{
          var workingtimes = await axios.get(
            `http://localhost:4000/admin/workingtimes/${this.Uid}?start=${startDate}&end=${endDate}`,{
                    headers: {
                      Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                      "x-csrf-token": `${localStorage.getItem('csrf')}`
                    } 
              }
          )
          let responses = workingtimes.data.length;

          for(let d = 0; d < 7; d++){
            hours.set(d,0);
            for (let i = 0; i < responses; i++) {
              var start = new Date(workingtimes.data[i].start);
              var end = new Date(workingtimes.data[i].end);
              var time = (end-start)/(1000*3600);
              if(start.getDay() == d){
                hours.set(d,hours.get(d)+time);
              }
            } 
          }
          for(let d = 0; d < 7; d++){
            hoursF.push(hours.get(d));
          }
          colors.push(this.RandomColor());
          this.data = {
          labels : ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
            datasets: [
                {
                    backgroundColor: colors,
                    labels: ["hours"],
                    data: hoursF
                }
              ]
          }
        }catch (error){
          this.data = {
            labels : ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
            datasets: [
                {
                    backgroundColor: ['#41B883'],
                    data: [1]
                }
              ]
          }
        }
      }
      else{
        let monday = this.getDayOfCurrentWeek(1).toISOString().substr(0, 10);
        let sunday = this.getDayOfCurrentWeek(7).toISOString().substr(0, 10);

        let startDate = monday + "T00:00:01Z";
        let endDate = sunday + "T23:59:59Z";

        var hours = new Map();
        var hoursF= [];

        var colors= [];
        try{
          var workingtimes = await axios.get(
            `http://localhost:4000/user/workingtimes?start=${startDate}&end=${endDate}`,{
                    headers: {
                      Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                      "x-csrf-token": `${localStorage.getItem('csrf')}`
                    } 
              }
          )
          let responses = workingtimes.data.length;

          for(let d = 0; d < 7; d++){
            hours.set(d,0);
            for (let i = 0; i < responses; i++) {
              var start = new Date(workingtimes.data[i].start);
              var end = new Date(workingtimes.data[i].end);
              var time = (end-start)/(1000*3600);
              if(start.getDay() == d){
                hours.set(d,hours.get(d)+time);
              }
            } 
          }
          for(let d = 0; d < 7; d++){
            hoursF.push(hours.get(d));
          }
          colors.push(this.RandomColor());
          this.data = {
          labels : ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
            datasets: [
                {
                    backgroundColor: colors,
                    labels: ["hours"],
                    data: hoursF
                }
              ]
          }
        }catch (error){
          this.data = {
            labels : ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
            datasets: [
                {
                    backgroundColor: ['#41B883'],
                    data: [1]
                }
              ]
          }
        }
      }


       
    },
    RandomColor(){
      var letters = "0123456789ABCDEF";
      var color = '#';
      for (var i = 0; i < 6; i++)
       color += letters[(Math.floor(Math.random() * 16))];
      return color;
    },
    getDayOfCurrentWeek( day) {
      const today = new Date();
      const first = today.getDate() - today.getDay() + day;

      const monday = new Date(today.setDate(first));
      return monday;
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
