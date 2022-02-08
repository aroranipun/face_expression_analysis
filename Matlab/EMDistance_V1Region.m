function [EMDist] = EMDistance_V1Region(MovieFace,Face7, FaceRegion)
%EMDistance_V1Region Get the EMD profile for V1 region using as reference
%the 7 FUME and tracking the distance along the trajectory of the movie,
%frame by frame
%   Detailed explanation goes here: Takes the Movie of the V1 region frame
%   by frame and the reference 7 FUME V1 and outputs the frame by frame
%   profile of the movie to inform which emotion the speech of the person
%   is closer to
%   region flag indicates which area of the face we are interrogating

nbins = 10;
NFRAMES_MOVIE=size(MovieFace,2);
FUME7=7;

for i=1:NFRAMES_MOVIE
    for j=1:FUME7
        % here determine the region to interrogate
        switch FaceRegion
            case 1
                if ~isempty(MovieFace(i).V1)
                    A=findpeaks(MovieFace(i).V1.MicroMov_full);
                    B=findpeaks(Face7(j).V1.MicroMov_full);
                    
                    [ca ha] = hist(A, nbins);
                    [cb hb] = hist(B, nbins);
                    
                    F1 = ha';
                    F2 = hb';
                    
                    %Weights
                    W1 = ca / sum(ca); W1=W1';
                    W2 = cb / sum(cb); W2=W2';
                    
                    Func=@gdf;  %ground distance function
                    [x, fval] = emd(F1, F2, W1, W2, Func);
                    EMDist(i,j)=fval;
                end
            
            case 2
                if ~isempty(MovieFace(i).V2)
                    A=findpeaks(MovieFace(i).V2.MicroMov_full);
                    B=findpeaks(Face7(j).V2.MicroMov_full);
                    
                    [ca ha] = hist(A, nbins);
                    [cb hb] = hist(B, nbins);
                    
                    F1 = ha';
                    F2 = hb';
                    
                    %Weights
                    W1 = ca / sum(ca); W1=W1';
                    W2 = cb / sum(cb); W2=W2';
                    
                    Func=@gdf;  %ground distance function
                    [x, fval] = emd(F1, F2, W1, W2, Func);
                    EMDist(i,j)=fval;
                end
            
            case 3
                if ~isempty(MovieFace(i).V3)
                    A=findpeaks(MovieFace(i).V3.MicroMov_full);
                    B=findpeaks(Face7(j).V3.MicroMov_full);
                    
                    [ca ha] = hist(A, nbins);
                    [cb hb] = hist(B, nbins);
                    
                    F1 = ha';
                    F2 = hb';
                    
                    %Weights
                    W1 = ca / sum(ca); W1=W1';
                    W2 = cb / sum(cb); W2=W2';
                    
                    Func=@gdf;  %ground distance function
                    [x, fval] = emd(F1, F2, W1, W2, Func);
                    EMDist(i,j)=fval;
                end
                
            otherwise
                display('Enter the correct region 1,2,or 3')
                return;
        end
    end
end

end

