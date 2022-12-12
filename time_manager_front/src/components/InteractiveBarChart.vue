<template>
    <div class="container workingTime mt-5">
      <h2>Actual Working Time</h2>
      <BarChartVue :chart-data="data"  />
    </div>
  </template>
  
  <script>
  import { defineComponent } from "@vue/runtime-core";
  import BarChartVue from "./BarChart.vue";
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
      BarChartVue,
    },
    methods: {
      async updateChart() {
        
        let now = new Date().toISOString();
        let startDate = this.day + "T00:00:01Z";
        let endDate = this.day + "T23:59:59Z";
        var ActualWT;
        var ActualClock;

        


        let Hours = [];

        try{

          if(localStorage.getItem('roleID')==2){
            let clocks = await axios.get(
                `http://localhost:4000/admin/clocks/1`,{
                  headers: {
                    Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${window.localStorage.getItem('csrf')}`
                  } 
            })
            var clock = clocks.data;
            var workingtimes = await axios.get(
                `http://localhost:4000/admin/workingtimes/1?start=${startDate}&end=${endDate}`,{
                  headers: {
                    Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${window.localStorage.getItem('csrf')}`
                  } 
            }
            )
            var workingTime = workingtimes.data;
          }
          else{
            let clocks = await axios.get(
                `http://localhost:4000/user/clocks/`,{
                  headers: {
                    Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${window.localStorage.getItem('csrf')}`
                  } 
            })
            var clock = clocks.data;
            var workingtimes = await axios.get(
                `http://localhost:4000/user/workingtimes/?start=${startDate}&end=${endDate}`,{
                  headers: {
                    Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
                    "x-csrf-token": `${window.localStorage.getItem('csrf')}`
                  } 
            }
            )
            var workingTime = workingtimes.data;
          }
            

            

            for (let c = 0; c < clock.length; c++) {
                if(clock[c].time <= now && clock[c].status == true){
                    ActualClock = clock[c];
                }
            }

            for (let w = 0; w < workingTime.length; w++) {
                if(workingTime[w].start <= now && workingTime[w].end >= now){
                    ActualWT = workingTime[w];
                }
            }

            let WTstart = new Date(ActualWT.start).getHours() +"."+new Date(ActualWT.start).getMinutes();
            let WTend = new Date(ActualWT.end).getHours() +"."+new Date(ActualWT.end).getMinutes();


            Hours.push([WTstart,WTend]);




            let Cstart = new Date(ActualClock.time).getHours() +"."+new Date(ActualClock.time).getMinutes();
            let Now = new Date().getHours() + "." + new Date().getMinutes();

            Hours.push([Cstart,Now]);

            Hours.push([Now,WTend]);

            this.data = {
                labels : ["Current WorkingTime duration","Hours done","Hours remaining"],
                datasets: [
                    {
                        backgroundColor: ['#ff0000','#00ff00','#0000ff'],
                        data: Hours
                    }
                ]
            }
        }catch (error){
          this.data = {
            labels : ["No WorkingTime Now"],
            datasets: [
                {
                    backgroundColor: ['#ff0000'],
                    data: [[7,19]]
                }
              ]
          }
        } 
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
    width: 69em;

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
  