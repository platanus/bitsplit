<template>
  <div class="m-12">
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
    <div
      class="flex flex-col justify-center md:flex-row md:justify-start bg-gray-200 p-10 rounded-md"
    >
      <div
        class="flex flex-col md:flex-row md:items-start text-center px-4 py-2"
      >
        <LinkButton
          classmod="bg-blue-500 hover:bg-blue-700 mx-4 my-3 md:my-0"
          :field-disabled="false"
          route="sign-in"
        >
          Iniciar sesion
        </LinkButton>
        <LinkButton
          classmod="bg-blue-500 hover:bg-blue-700 mx-4"
          :field-disabled="false"
          route="sign-up"
        >
          Registrarse
        </LinkButton>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters }  from 'vuex';
import LinkButton from '../components/LinkButton';

export default {
  name: 'Landing',
  data() {
    return {
      routeName: 'Landing',
    };
  },
  components: {
    LinkButton,
  },
  computed: {
    ...mapGetters('user', ['signedIn']),
  },
};
</script>

<style lang="scss"></style>
