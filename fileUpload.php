<?php
include('config.php');
?>
<html>
   <body>
      
      <form action = "fileUploadScript.php" method = "POST" enctype = "multipart/form-data">
         <input type = "file" name = "image" />
         <input type = "submit"/>
      </form>
      
	  
	  <div class="agile-grids">	
				<!-- tables -->
				
				<div class="agile-tables">
					<div class="w3l-table-info">
					  <h2></h2>
					  
					  
					  

					  
					    <table id="table" >
						<thead class="thead-dark">
						  <tr>
						  							<th>Image</th>
							<th>Level</th>
							

							
						  </tr>
						</thead>
						<tbody>
<?php $sql = "SELECT * from disease";
$query = $dbh->prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_ASSOC);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $result)
{				?>		
						  <tr>
							<?php echo "<td><img src='images/".htmlentities($result->pic)."' height = 160px width = 160px></td>";?></td>

							<td><?php echo htmlentities($result->disease);?></td>
							

													  </tr>
						 <?php $cnt=$cnt+1;} }?>
						</tbody>
					  </table>
					</div>
				  </table>

				
			</div>
   </body>
</html>