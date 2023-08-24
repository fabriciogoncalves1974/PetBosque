<?php 

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'delete' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Agendamento!']);exit;}

if($acao == 'delete' && $param != ''){

    $db = DB::conexao();
    $rs = $db->prepare("DELETE FROM agendamento WHERE id={$param}");
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados excluidos com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao excluir os dados!']);
       }

}
?>