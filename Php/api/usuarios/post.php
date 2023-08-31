<?php 

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'login' && $param == ''){
    Usuarios::login($_POST['login'], $_POST['senha']);
}
var_dump('usuariosPOST.php');

?>