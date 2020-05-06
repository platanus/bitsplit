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
          Monto: {{ this.lastPayment.amount }} BTC
        </textField>
        <textField>
          Receptor: {{ this.lastPayment.receiver }}
        </textField>
        <textField>
          Fecha: {{ getDateFormat(this.lastPayment.date) }}
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
      date: null
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
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment']),
    getDateFormat(date) {
      return format(date)
    }
  }
}

function format(UNIX_timestamp){
  var a = new Date(UNIX_timestamp);
  var months = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' de ' + month + ' ' + year + ' ' + hour + ':' + min;
  return time;
}
</script>

