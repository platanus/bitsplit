<template>
  <div class="flex justify-center m-16">
    <div class="flex flex-col mb-6 mt-6">
      <div>
        <textField fontSize="full" fontColor="secondary">
          ¡Pago realizado con éxito!
        </textField>
      </div>
      <div>
        <textField>
          Monto: {{ this.lastPayment.amount }}
        </textField>
        <textField>
          Receptor: {{ this.lastPayment.receiver }}
        </textField>
        <textField>
          Fecha: {{ this.lastPayment.date }}
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
    ...mapState('user', ['currentUser', 'userBalanceCLP', 
                         'userBalanceBTC', 'lastPayment'])
  },
  created() {
    this.getUserBalance()
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment'])
  }
}
</script>