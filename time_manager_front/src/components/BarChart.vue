<template>
    <Bar
       :chart-options="chartOptions"
       :chart-data="chartData"
       :chart-id="chartId"
       :dataset-id-key="datasetIdKey"
       :plugins="plugins"
       :css-classes="cssClasses"
       :styles="styles"
       :width="width"
       :height="height"
   />
</template>

<script>
import { Bar } from 'vue-chartjs'
import { defineComponent, h } from 'vue'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default defineComponent({
 name: 'BarChart',
 components: { Bar },
 props: {
   chartId: {
     type: String,
     default: 'bar-chart'
   },
   datasetIdKey: {
     type: String,
     default: 'label'
   },
   width: {
     type: Number,
     default: 400
   },
   height: {
     type: Number,
     default: 400
   },
   cssClasses: {
     default: '',
     type: String
   },
   styles: {
     type: Object,
     default: () => {}
   },
   plugins: {
     type: Object,
     default: () => {}
   }
 },
 setup(props) {
   const chartData = {
           labels: ["Today's expected hours","Time since clock in","Time Until Clock out (for a full day of work)"],
           datasets: [
               {
                 backgroundColor: ['grey','blue','Red'],
                 Color: ['grey','blue','Red'],
                 data: [[8,17],[8.5,14.2],[14.2,17.5]]
               }
           ]
   }

   const chartOptions = {
           responsive: true,
           scales: {
               y: {
                  beginAtZero: false,
                  suggestedMin: 11,
                  suggestedMax: 13,
               }
           }
       }

   return () =>
     h(Bar, {
       chartData,
       chartOptions,
       chartId: props.chartId,
       width: props.width,
       height: props.height,
       cssClasses: props.cssClasses,
       styles: props.styles,
       plugins: props.plugins
     })
 }
})
</script>

<style scoped>
div{
 background-color: rgb(255, 255, 255);
 margin-left: 30%;
 margin-right: 30%;
}
</style>