<template>
  <div v-on:click="CLEAR_ALERT()">
    <errorAlert v-if="alert.type==='error'"></errorAlert>
    <successAlert v-if="alert.type==='success'"></successAlert>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState, mapMutations } from 'vuex'

import errorAlert from './errorAlert'
import successAlert from './successAlert'

export default {
  name: 'alertMessage',
  components: {
    errorAlert,
    successAlert
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
