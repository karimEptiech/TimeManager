<template>
    <div>
      <Pie
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
    </div>     
</template>
    
<script>
import { defineComponent, h } from 'vue'

import { Pie } from 'vue-chartjs'
import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    ArcElement,
    CategoryScale
} from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale)

export default defineComponent({
    name: 'PieChart',
    components: {
    Pie
    },
    props: {
    chartId: {
        type: String,
        default: 'pie-chart'
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
        type: Array,
        default: () => []
    }
    },
    setup(props) {
        
        const chartData = {
            labels: ['Ben', 'Bruno', 'Non', 'Oui'],
            datasets: [
            {
                backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
                data: [8.5, 7.3, 8, 7]
            }
            ]
        }

        const chartOptions = {
            responsive: true,
            maintainAspectRatio: false
        }

        return () =>
            h(Pie, {
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