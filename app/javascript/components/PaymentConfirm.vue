<template>
  <div class="flex justify-center m-16">
    <div class="flex flex-col mb-6 mt-6">
      <div>
        <textField fontsize="full" textcolor="secondary">
          ¡Pago realizado con éxito!
        </textField>
      </div>
      <div>
        <textField>
          Monto: {{ this.lastPaymentAmount }}
        </textField>
        <textField>
          Receptor: {{ this.lastPaymentReceiver }}
        </textField>
        <textField>
          Fecha: {{ this.lastPaymentDate }}
        </textField>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import textField from '../components/TextField'

export default {
  name: 'PaymentConfirm',
  data() {
    return {
      routeName: 'PaymentRoute',
    }
  },
  components: {
    textField
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