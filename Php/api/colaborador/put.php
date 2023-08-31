<?php 

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'update' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Colaborador!']);exit;}
if($acao == 'inativar' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Colaborador!']);exit;}
if($acao == 'ativae' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Colaborador!']);exit;}

if($acao == 'update' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE colaborador SET ";
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
if($acao == 'inativar' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE colaborador SET status = 'Inativo' WHERE id={$param}";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados atualizados com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao atualizar os dados!']);
       }
}
if($acao == 'ativar' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE colaborador SET status = 'Ativo' WHERE id={$param}";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados atualizados com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao atualizar os dados!']);
       }
}

?>