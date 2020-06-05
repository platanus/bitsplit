// Todo agregar informacion general del usuario
<template>
  <div>
    <div class="txt-card lg:flex">
      <div class="w-1/3 text-center py-8">
        <div class="border-r">
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top">Bitsplit Wallet</span>
          </div>
          <div class="text-sm uppercase text-grey tracking-wide py-10">
            0.0003 BTC
          </div>
          <div class="text-sm uppercase text-grey tracking-wide">
            $ 6.000 CLP
          </div>
        </div>
      </div>
      <div class="w-1/3 text-center py-8">
        <div class="border-r">
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top"> Buda Wallet</span>
          </div>
          <div class="text-sm uppercase text-grey tracking-wide py-10">
            0.0006 BTC
          </div>
          <div class="text-sm uppercase text-grey tracking-wide">
            $ 3.000 CLP
          </div>
        </div>
      </div>
      <div class="w-1/3 text-center py-8">
        <div>
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top"> Splitwise </span>
          </div>
          <div class="text-sm text-grey tracking-wide py-10">
            Me deben: $ 5.000
          </div>
          <div class="text-sm text-grey tracking-wide">
            Debo a amigos: $ 3.000
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'ProfileHome',
};
</script>
