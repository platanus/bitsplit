<template>
  <div class="flex justify-center">
    <div class="flex inline-flex border-2 border-black mr-2 rounded">
      <select v-model="selectedDay" class="p-2">
        <option v-for="day in days" :key="day.day" :value="day.day">
          {{ day.day }}
        </option>
      </select>
    </div>
    <div class="flex inline-flex border-2 border-black mr-2 rounded">
      <select v-model="selectedMonth" @change="updateDays()" class="p-2">
        <option
          v-for="(month, index) in months"
          :value="index"
          :key="month.month"
        >
          {{ month.month }}
        </option>
      </select>
    </div>
    <div class="flex inline-flex border-2 border-black rounded">
      <select v-model="selectedYear" @change="updateDays()" class="p-2">
        <option v-for="year in years" :key="year.year" :value="year.year">
          {{ year.year }}
        </option>
      </select>
    </div>
  </div>
</template>

<script>
const defaultMonths = {
  0: 'Enero',
  1: 'Febrero',
  2: 'Marzo',
  3: 'Abril',
  4: 'Mayo',
  5: 'Junio',
  6: 'Julio',
  7: 'Agosto',
  8: 'Septiembre',
  9: 'Octubre',
  10: 'Noviembre',
  11: 'Diciembre',
};

/* eslint no-magic-numbers: ["error", { "ignore": [10,1, 12, 101, 0] }]*/

export default {
  name: 'DateDropdown',
  props: {
    default: {
      default: '2020-01-01',
      type: String,
      required: false,
    },
    min: {
      default: '1930',
      type: String,
      required: false,
    },
    max: {
      default: '2020',
      type: String,
      required: false,
    },
  },
  data() {
    return {
      days: [],
      selectedDay: '',
      selectedMonth: '',
      selectedYear: '',
    };
  },
  computed: {
    initialDate() {
      return !!(this.default || this.min);
    },
    specifiedDate() {
      return new Date(this.default);
    },
    minDate() {
      return new Date(this.min);
    },
    maxDate() {
      return new Date(this.max);
    },
    calculatedDate() {
      const day =
        this.selectedDay >= 10 ? this.selectedDay : `0${this.selectedDay}`;
      const month =
        this.selectedMonth + 1 >= 10
          ? this.selectedMonth + 1
          : `0${this.selectedMonth + 1}`;

      return `${day}.${month}.${this.selectedYear}`;
    },
    months() {
      const months = [];
      for (let i = 0; i < 12; i++) {
        months.push(defaultMonths[i]);
      }

      return months.map((month, index) => ({
        month,
        selected: index === this.selectedMonth,
      }));
    },
    years() {
      let firstYear;
      if (this.min) {
        firstYear = this.minDate.getFullYear();
      } else if (this.default) {
        firstYear = this.specifiedDate.getFullYear();
      } else {
        firstYear = new Date().getFullYear();
      }
      const through = this.max
        ? this.maxDate.getFullYear() + 1 - firstYear
        : 101;
      const years = [];
      for (let i = firstYear, len = firstYear + through; i < len; i++) {
        years.push(i);
      }

      return years.map(year => ({
        year,
        selected: year === this.selectedYear,
      }));
    },
  },
  methods: {
    getDays() {
      const days = [];
      const daysNumberOfMonth = new Date(
        this.selectedYear,
        this.selectedMonth + 1,
        0
      ).getDate();
      for (let i = 1; i < daysNumberOfMonth + 1; i++) days.push(i);

      return days.map(day => ({ day, selected: days === this.selectedDay }));
    },
    updateDays() {
      this.days = this.getDays();
    },
    sendDate() {
      const date = this.format
        ? this.format(this.calculatedDate)
        : this.calculatedDate;
      this.$emit('input', date);
    },
    // eslint-disable-next-line max-statements
    setDate() {
      this.updateDays();
      let date;
      if (this.min && this.max && !this.default) {
        date = new Date(this.min);
      } else if (this.default) {
        date = new Date(this.default);
      } else {
        date = new Date();
      }
      if (this.initialDate) this.selectedDay = date.getDate() + 1;
      else this.selectedDay = date.getDate();
      this.selectedDay = date.getDate();
      this.selectedMonth = date.getMonth();
      this.selectedYear = date.getFullYear();
      this.sendDate();
    },
  },
  created() {
    this.setDate();
  },
  updated() {
    this.sendDate();
  },
};
</script>

<style scoped></style>
