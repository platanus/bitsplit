<template>
  <div class="m-12 bg-primary bg-screen">
    <div class="bg-gray-200 p-10 my-4 rounded-md">
      <p class="text-5xl font-bold">
        BitSplit
      </p>
      <p class="font-light">
        Bienvenido a BitSplit, el sitio donde podrás pagar facilmente a tus
        amigos, cobrar deudas y manejar dinero. Todo esto de forma fácil,
        intuitiva e internacional!
      </p>
    </div>
    <div class="flex flex-col lg:flex-row justify-between rounded-md">
      <div
        class="bg-gray-200 p-10 lg:mr-10 lg:self-auto self-center lg:w-auto w-full flex flex-col lg:block lg:justify-start mb-10 lg:mb-0"
      >
        <UserCard classmod="mx-auto" />
        <div class="flex justify-center mt-6">
          <submitButton>
            <router-link to="/payment">
              Hacer un pago
            </router-link>
          </submitButton>
        </div>
      </div>
      <div class="bg-gray-200 px-10 rounded-md flex-grow pt-2">
        <SplitwiseIndex />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import submitButton from '../components/SubmitButton';
import UserCard from '../components/UserCard';
import SplitwiseIndex from './SplitwiseIndex';

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      tableColumns: [
        'Tipo',
        'Envía',
        'Recibe',
        'Cantidad BTC',
        'Cantidad CLP',
        'Fecha',
      ],
    };
  },
  created() {
    this.getPayments();
  },
  components: {
    submitButton,
    UserCard,
    SplitwiseIndex,
  },
  methods: {
    ...mapActions('paymentsHistory', ['getPayments']),

    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'getPaymentsLoading']),
    ...mapState('paymentsHistory', ['userPaymentsHistory']),
    ...mapGetters('user', ['splitwiseSignedIn']),
  },
};
</script>

<style></style>
