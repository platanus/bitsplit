<template>
  <div>
    <div>
      <div>
        Monto: {{ this.lastPaymentAmount }}
      </div>
      <div>
        Receptor: {{ this.lastPaymentReceiver }}
      </div>
      <div>
        Fecha: {{ this.lastPaymentDate }}
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'

export default {
  name: 'PaymentConfirm',
  data() {
    return {
      routeName: 'PaymentRoute',
    }
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC',
                'lastPaymentAmount','lastPaymentReceiver','lastPaymentDate'])
  },
  created() {
    this.getUserBalance()
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment'])
  }
}
</script>