<template>
  <div>
    Pago confirmado
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'

export default {
  name: 'Payment',
  data() {
    return {
      routeName: 'PaymentRoute',
    }
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC'])
  },
  created() {
    this.getUserBalance()
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment'])
  }
}
</script>
