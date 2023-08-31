<?php 

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'update' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Agendamento!']);exit;}
if($acao == 'cancelar' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Agendamento!']);exit;}
if($acao == 'finalizar' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Agendamento!']);exit;}

if($acao == 'update' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE agendamento SET ";
    $contador = 1;
    foreach(array_keys($_POST) as $indice){
        if(count($_POST) > $contador){
            $sql .= "{$indice} = '{$_POST[$indice]}', ";
        } else {
            $sql .= "{$indice} = '{$_POST[$indice]}' ";
        }
        $contador ++;
    }
    $sql .= "WHERE id={$param}";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados atualizados com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao atualizar os dados!']);
       }
}
if($acao == 'finalizar' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE agendamento SET status = 'Finalizado' WHERE id={$param}";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Agendamento finalizado com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao finalizar agendamento!']);
       }
}
if($acao == 'cancelar' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE agendamento SET status = 'Cancelado' WHERE id={$param}";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Agendamento cancelado com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao cancelar agendamento!']);
       }
}

?>