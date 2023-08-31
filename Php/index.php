<?php




header('Access-Control-Allow-Origin: *');
header('Content-type: application/json');

date_default_timezone_get('America/Sao_Paulo');

if(isset($_GET['path'])){
    $path = explode("/", $_GET['path']);
}else{
    echo "Caminho não existe";exit;
}

if(isset($path[0])) { $api = $path[0];} else {echo "Caminho não existe";exit;}
if(isset($path[1])) { $acao = $path[1];} else {$acao = '';}
if(isset($path[2])) { $param = $path[2];} else {$param = '';}
if(isset($path[3])) { $param2 = $path[3];} else {$param2 = '';}

$method = $_SERVER['REQUEST_METHOD'];


@include_once "classes/conexao.php";
@include_once "classes/jwt.class.php";
@include_once "classes/usuarios.class.php";

@include_once "api/usuarios/usuarios.php";
@include_once "api/clientes/clientes.php";
@include_once "api/pet/pet.php";
@include_once "api/colaborador/colaborador.php";
@include_once "api/planos/planos.php";
@include_once "api/agendamento/agendamento.php";
@include_once "api/hospedagem/hospedagem.php";

?>