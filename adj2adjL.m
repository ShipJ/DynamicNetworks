% Function borrowed from: 
function L = adj2adjL(adj)
L=cell(length(adj),1);
for i=1:length(adj); L{i}=find(adj(i,:)>0); end