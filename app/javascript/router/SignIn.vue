<template>
  <div class="items-center h-screen w-full bg-primary p-12 mt-24">
    <center>
      <div class="w-full max-w-xs ">
        <img
          :src="bitsplitLogo"
          class="mb-10"
          align="top"
        >
        <form
          @submit.prevent="handleSubmit"
          class="bg-primary rounded pt-6 pb-8 mb-4 "
        >
          <div class="mb-4">
            <textInput
              field-id="email"
              field-type="text"
              field-placeholder="Correo"
              field-name="email"
              v-model="email"
            />
          </div>
          <div>
            <passwordInput
              field-id="password"
              field-name="password"
              field-placeholder="Contraseña"
              v-model="password"
            />
          </div>
          <submitButton :loading="signInLoading">
            Ingresar
          </submitButton>
          <p class="txt-field items-center mt-10 underline ">
            <router-link :to="signUpRoute">
              Crear una cuenta
            </router-link>
          </p>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import textInput from '../components/Input';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import logo from '../assets/bitsplit-logo.svg';

export default {
  name: 'SignIn',
  data() {
    return {
      routeName: 'Sign In',
      email: '',
      password: '',
      signUpRoute: 'sign-up',
      bitsplitLogo: logo,
    };
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
  },
  computed: {
    ...mapState('user', ['currentUser', 'signInLoading']),
  },
  methods: {
    ...mapActions('user', ['signIn']),
    handleSubmit() {
      const { email, password } = this;
      if (email && password) {
        this.signIn({ email, password })
          .then(() => {
            // TODO logger
          })
          .catch(() => {
            console.error('error');
          });
      }
    },
  },
};
</script>
