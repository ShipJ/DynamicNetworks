% Function borrowed from: 
function rtn = purge(A, B)

new_list = [];
for a = 1 : numel(A); 
  if isempty(find(B == A(a))) 
      new_list=[new_list, A(a)]; 
  end
end

rtn = new_list;
end