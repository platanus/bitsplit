<template>
  <div v-if="alert.message" :class="`alert ${alert.type}`">
    {{ alert.message }}
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
export default {
  name: 'alertMessage',
  computed: {
    ...mapState({
      alert: state => state.alert
    })
  }
}
</script>
