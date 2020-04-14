<template>
  <div v-on:click="CLEAR_ALERT()">
    <error-alert v-if="alert.type==='error'" />
    <success-alert v-if="alert.type==='success'" />
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState, mapMutations } from 'vuex'

import errorAlert from './errorAlert'
import successAlert from './successAlert'

export default {
  name: 'alertMessage',
  components: {
    'error-alert': errorAlert,
    'success-alert': successAlert
  },
  methods: {
    ...mapMutations('alert', ['CLEAR_ALERT'])
  },
  computed: {
    ...mapState({
      alert: state => state.alert
    })
  }
}
</script>
