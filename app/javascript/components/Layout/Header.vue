<template>
    <header>
    </header>
</template>


<script>
export default {
  name: 'header',
  data () {
    return {
        title: 'header'
    }
  }
}
</script>

<style>
header{
    background: rgb(154, 172, 179);
    padding: 15px;
    text-align: center;
}
a{
    color: blanchedalmond;
    padding: 6px 8px;
    }
.router-link-active{
    background: lightcoral;
    color: black;
    }

</style>