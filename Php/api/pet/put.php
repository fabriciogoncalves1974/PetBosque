<?php 

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'update' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Pet!']);exit;}

if($acao == 'contaPlano' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'contaPlano' && $param != '' && $param2 == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'renovaPlano' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'renovaPlano' && $param != '' && $param2 == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'planoVencido' && $param == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'planoVencido' && $param != '' && $param2 == ''){echo json_encode(['ERRO' => 'É necessario informar um Parametro!']);exit;}

if($acao == 'update' && $param != ''){

    array_shift($_POST);

    $sql = "UPDATE pet SET ";
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

if($acao == 'contaPlano' && $param != '' && $param2 != ''){
 
    array_shift($_POST);

    $sql = "UPDATE pet SET contaPlano = '$param' WHERE id=$param2";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados atualizados com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao atualizar os dados!']);
       }
}
if($acao == 'renovaPlano' && $param != '' && $param2 != ''){
 
    array_shift($_POST);

    $sql = "UPDATE pet SET contaPlano = '$param' WHERE id=$param2";
    
    $db = DB::conexao();
    $rs = $db->prepare($sql);
    $exec = $rs->execute();

    if($exec){
        echo json_encode(["dados" => 'Dados atualizados com sucesso!']);
       } else{
         echo json_encode(["dados" => 'Erro ao atualizar os dados!']);
       }
}
if($acao == 'planoVencido' && $param != '' && $param2 != ''){
 
    array_shift($_POST);

    $sql = "UPDATE pet SET planoVencido = '$param' WHERE id=$param2";
    
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