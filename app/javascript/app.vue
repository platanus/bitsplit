<template>
  <div id="vue-app">
    <div v-if="alert.message" :class="`alert ${alert.type}`">
      {{ alert.message }}
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  name: 'app',
  computed: {
    ...mapState({
      alert: state => state.alert
    })
  },
  methods: {
    ...mapActions('alert', ['clear_alert'])
  },
  watch: {
    $route(to, from) {
      // clear alert on location change
      this.clear_alert()
    }
  }
}
</script>
