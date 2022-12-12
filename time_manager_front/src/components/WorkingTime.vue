<template>
  <div >
    <div class="container mt-3">
      <div class="row flex-lg-nowrap">
        <div class="col">
          <div class="row flex-lg-nowrap">
            <div class="col mb-3">
              <div class="e-panel card">
                <div class="card-body">
                  <div class="card-title">
                    <h6 class="mr-2">
                      <span>My WorkingTimes</span><small class="px-1"></small>
                    </h6>
                  </div>
                  <div class="e-table">
                    <div class="table-responsive table-lg mt-3">
                      <table class="table table-bordered">
                        <thead>
                          <tr>
                            <th class="align-top">
                              <div
                                class="custom-control custom-control-inline custom-checkbox custom-control-nameless m-0">
                                <input type="checkbox" v-model="initialBox" true-value="yes" false-value="no"
                                  class="custom-control-input " id="all-items">
                              </div>
                            </th>
                            <th class="max-width">Id</th>
                            <th class="sortable">Start</th>
                            <th class="end">End</th>
                            <th>Clocks</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="workingTime in workingTimes" :key="workingTime.id">
                            <td class="align-middle">
                              <div
                                class="custom-control custom-control-inline custom-checkbox custom-control-nameless m-0 align-top">
                                <input @click="changeSelected($event)" type="checkbox"
                                  class="custom-control-input myCheckBoxs" id="item-2">
                                <label class="custom-control-label" for="item-2"></label>
                              </div>
                            </td>
                            <td class=" text-center text-nowrap align-middle">
                              {{ workingTime.id }}
                            </td>
                            <td class="text-nowrap text-center align-middle">
                              <span>{{ workingTime.start.substr(0, 10) }}</span>
                            </td>
                            <td class="text-nowrap  text-center align-middle">
                              <span>{{ workingTime.end.substr(0, 10) }}</span>
                            </td>
                            <td class="text-center align-middle">
                              <i class="fa fa-fw text-secondary cursor-pointer fa-toggle-on"></i>
                              <div class="btn-group align-top">
                                futur clock
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div>
      <InteractiveLineChart :Uid="routeId"/>
    </div>
  </div>
</template>

<script>
import InteractiveLineChart from "./InteractiveLineChart.vue"
import { ref, onMounted } from 'vue';
import axios from "axios";
export default {



  name: "workingTime",
  data() {
    return {
      startDate: new Date().toISOString().substr(0, 10),
      endDate: new Date().toISOString().substr(0, 10),
      userID: "123",
      routeId: this.$route.params.id,
      workingTimes: null,
      activeUserID: window.localStorage.getItem("userID")
    }
  },

  mounted: {
    test() {
      console.log(window.localStorage.getItem('userID'))
    }
  },
  methods: {
    createWorkingTime() {
      console.log(this.startDate)
      let data = {
        start: this.startDate + ':00Z',
        end: this.endDate+ ':00Z'
      }
      axios
        .post(`http://localhost:4000/admin/workingtimes/${this.userID}`, data,
        {
          headers: {
            Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
            "x-csrf-token": `${window.localStorage.getItem('csrf')}`
          }
        })
        .then((response) => {
          alert('workingtime created succesfuly')
          console.log(response);
        }).catch((error) => {
          console.log('something went wrong' + error)
        })
    },
    getWorkingTimesById() {
      console.log($route.params.id)
      if(localStorage.getItem('roleID')==2){
        const start = "2008-01-26T23:50:07Z"
        const end = "2023-01-27T23:50:07Z"
        axios
          .get('http://localhost:4000/admin/workingtimes/' + this.routeId + '?start=' + start + '&end=' + end,{
                    headers: {
                      Authorization: `Bearer ${window.localStorage.getItem('jwt')}`,
                      "x-csrf-token": `${window.localStorage.getItem('csrf')}`
                    } 
              })
          .then((response) => {
            console.log(response.data);
            this.workingTimes = response.data

          }).catch((error) => {
            console.log('something went wrong' + error)
          })
      }
      else{
        const start = "2008-01-26T23:50:07Z"
        const end = "2023-01-27T23:50:07Z"
        axios
          .get('http://localhost:4000/user/workingtimes/?start=' + start + '&end=' + end,{
                    headers: {
                      Authorization: `Bearer ${localStorage.getItem('jwt')}`,
                      "x-csrf-token": `${localStorage.getItem('csrf')}`
                    } 
              })
          .then((response) => {
            console.log(response.data);
            this.workingTimes = response.data

          }).catch((error) => {
            console.log('something went wrong' + error)
          })
      }
      
    }
  },
  components:{
    InteractiveLineChart
  },
  mounted() {
    console.log('debut du get all')
    this.getWorkingTimesById()
  }
}

</script>


<style scoped>
.datePicker {
  width: 300px;
}

.btnValidation {
  background-color: #AAAEB7;
  box-shadow: 1px 1px #e6e4e4;
}

.btnValidation:hover {
  background-color: #8f939c;
}

.workingTime {
  border: #AAAEB7 2px solid;
  border-radius: 4px;
}

.userID {
  display: grid;

}

.userIDInput {
  border: 1px solid #AAAEB7;
  width: 100px;
  border-radius: 4px;

}

.input-group-append {
  cursor: pointer;
}
</style>
